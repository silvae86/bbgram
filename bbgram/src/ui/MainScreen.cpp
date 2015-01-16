#include "MainScreen.h"
#include "../Storage.h"
#include "../Telegraph.h"

#include <bb/ApplicationInfo>
#include <bb/cascades/Application>
#include <bb/system/InvokeManager>
#include <bb/system/InvokeRequest>
#include <bb/PpsObject>


using namespace bb::cascades;
using namespace bb::system;
using namespace bb::platform;

MainScreen* MainScreen::m_instance = NULL;

struct CreateGroupData
{
    tgl_peer_id_t* peers;
    QString chatPhoto;
};

MainScreen* MainScreen::instance()
{
    return m_instance;
}

MainScreen::MainScreen(ApplicationUI* app)
    : Screen("asset:///ui/pages/Main.qml")
        , m_app(app), m_appFullScreen(true)
{
    Q_ASSERT(m_instance == NULL);
    m_instance = this;

    m_contacts = new ContactList(Storage::instance()->contacts());
    m_contacts->setParent(this);
    m_dialogs = new ChatList(Storage::instance()->dialogs());
    m_dialogs->setParent(this);
    setContextProperty("_contacts", m_contacts);
    setContextProperty("_chats", m_dialogs);

    QObject::connect(bb::Application::instance(), SIGNAL(thumbnail()), this, SLOT(onAppThumbnail()));
    QObject::connect(bb::Application::instance(), SIGNAL(invisible()), this, SLOT(onAppThumbnail()));
    QObject::connect(bb::Application::instance(), SIGNAL(fullscreen()), this, SLOT(onAppFullScreen()));

    QObject::connect(Storage::instance(), SIGNAL(newMessageReceived(const Message*)), this, SLOT(onMessageReceived(const Message*)));

    QObject::connect(&m_notificationTimer, SIGNAL(timeout()), this, SLOT(showNotifications()));

    m_notificationTimer.setSingleShot(false);


    Telegraph::instance()->exportAuthorization();
    initialize();
}

MainScreen::~MainScreen()
{
    m_instance = NULL;
}

void MainScreen::addContact(const QString& firstName, const QString& lastName, const QString& phone)
{
    if (!contactExist(phone))
        tgl_do_add_contact(gTLS, phone.toUtf8().data(), phone.toUtf8().size(), firstName.toUtf8().data(), firstName.toUtf8().size(), lastName.toUtf8().data(), lastName.toUtf8().size(), false, MainScreen::_contactAddHandler, NULL);
    else
        emit contactAdded(true, "Contact already exists");
}

void MainScreen::renameContact(const QString& firstName, const QString& lastName, const QString& phone)
{
    if (contactExist(phone))
        tgl_do_add_contact(gTLS, phone.toUtf8().data(), phone.toUtf8().size(), firstName.toUtf8().data(), firstName.toUtf8().size(), lastName.toUtf8().data(), lastName.toUtf8().size(), false, MainScreen::_contactRenameHandler, NULL);
    else
        emit contactRenamed(true, "Contact not exist");
}

void MainScreen::deleteContact(User* contact)
{
    tgl_peer_id_t peer;
    peer.type = contact->type();
    peer.id = contact->id();
    tgl_do_del_contact(gTLS, peer, MainScreen::_contactDeleteHandler, contact);
}

void MainScreen::setProfilePhoto(const QString& fileName)
{
    tgl_do_set_profile_photo(gTLS, fileName.toUtf8().data(), NULL, NULL);
}

void MainScreen::sendMessage(Peer* peer, const QString& message)
{
    QByteArray bytes = message.toUtf8();
    if (peer->type() == TGL_BROADCAST_CHAT)
    {
        BroadcastChat* chat = (BroadcastChat*)peer;

        GroupDataModel* members = (GroupDataModel*)chat->members();

        tgl_peer_id_t* peers = new tgl_peer_id_t[members->size()];

        int idx = 0;
        for (QVariantList indexPath = members->first(); !indexPath.isEmpty(); indexPath = members->after(indexPath))
        {
            User* user = (User*)members->data(indexPath).value<QObject*>();
            peers[idx].type = user->type();
            peers[idx].id = user->id();
            idx++;
        }

        tgl_do_send_broadcast(gTLS, members->size(), peers, bytes.data(), bytes.length(), MainScreen::_broadcastSended, chat);

        delete[] peers;

        //void tgl_do_send_broadcast (struct tgl_state *TLS, int num, tgl_peer_id_t id[], const char *text, int text_len, void (*callback)(struct tgl_state *TLS, void *extra, int success, int num, struct tgl_message *ML[]), void *callback_extra);
    }
    else
        tgl_do_send_message(gTLS, {peer->type(), peer->id()}, (const char*)bytes.data(), bytes.length(), 0, 0);
}

void MainScreen::sendPhoto(Peer* peer, const QString& fileName)
{
    tgl_do_send_document(gTLS, 0, {peer->type(), peer->id()}, fileName.toUtf8().data(), NULL, NULL);
}

void MainScreen::deleteMessage(long long id)
{
    Storage::instance()->deleteMessage(id);
}

void MainScreen::markRead(Peer* peer)
{
    if (peer->type() == TGL_BROADCAST_CHAT)
        return;

    tgl_do_mark_read(gTLS, {peer->type(), peer->id()}, 0, 0);
}

void MainScreen::createGroup(QVariantList users, const QString& title, const QString& chatPhoto)
{
    CreateGroupData* data = new CreateGroupData;

    data->peers = new tgl_peer_id_t[users.size()];
    data->chatPhoto = chatPhoto;

    int idx = 0;
    foreach (QVariant variant, users)
    {
        User* user = (User*)variant.value<QObject*>();
        tgl_peer_id_t peer = {TGL_PEER_USER, user->id()};
        data->peers[idx] = peer;
        idx++;
    }

    tgl_do_create_group_chat_ex(gTLS, users.size(), data->peers, title.toUtf8().data(), MainScreen::_createGroupCallback, data);
}

void MainScreen::createBroadcast(QVariantList users)
{
    Storage::instance()->createBroadcast(users);
}

void MainScreen::setGroupName(GroupChat* group, const QString& title)
{
    if (group->type() == TGL_BROADCAST_CHAT)
        group->setTitle(title);
    else
        tgl_do_rename_chat(gTLS, {group->type(), group->id()}, title.toUtf8().data(), NULL, NULL);
}

void MainScreen::addUserToGroup(GroupChat* group, User* user)
{
    tgl_do_add_user_to_chat(gTLS, {group->type(), group->id()}, {user->type(), user->id()}, 0, MainScreen::_addMemberCallback, user);
}

void MainScreen::deleteMemberFromGroup(GroupChat* group, User* member)
{
    tgl_do_del_user_from_chat(gTLS, {group->type(), group->id()}, {member->type(), member->id()}, MainScreen::_deleteMemberCallback, member);
}

void MainScreen::deleteHistory(Peer* peer)
{
    Storage::instance()->deleteHistory(peer);
}

void MainScreen::deleteChat(Peer* peer)
{
    User* currentUser = (User*)Storage::instance()->getPeer(TGL_PEER_USER, gTLS->our_id);
    if (peer->type() == TGL_PEER_CHAT)
    {
        tgl_do_del_user_from_chat(gTLS, {peer->type(), peer->id()}, {currentUser->type(), currentUser->id()}, MainScreen::_deleteSelfFromGroupCallback, peer);
    }
    else
    {
        Storage::instance()->deleteHistory(peer);
        Storage::instance()->deleteChat(peer);
    }
}

void MainScreen::openFAQ()
{
    InvokeRequest request;
    request.setTarget("sys.browser");
    request.setAction("bb.action.OPEN");
    request.setUri("http://telegram.org/faq");
    InvokeManager mgr;
    mgr.invoke(request);
}

void MainScreen::sendInviteText(const QString& recipient, const QString& text)
{
    InvokeRequest request;
    request.setTarget("sys.pim.text_messaging.composer");
    request.setAction("bb.action.COMPOSE");
    request.setMimeType("application/text_messaging");
    QVariantMap map;
    map.insert("to", QVariantList() << recipient);
    map.insert("body", text);
    map.insert("send", false);
    QByteArray requestData = bb::PpsObject::encode(map, NULL);
    request.setData(requestData);
    InvokeManager mgr;
    mgr.invoke(request);
}

void MainScreen::dialANumber(const QString& number)
{
    InvokeRequest request;
    request.setAction("bb.action.DIAL");
    request.setMimeType("application/vnd.blackberry.phone.startcall");
    QVariantMap map;
    map.insert("number", number);
    QByteArray requestData = bb::PpsObject::encode(map, NULL);
    request.setData(requestData);
    InvokeManager mgr;
    mgr.invoke(request);
}

void MainScreen::initialize()
{
    if (!gTLS->DC_working || !tgl_signed_dc(gTLS, gTLS->DC_working))
    {
        QTimer::singleShot(200, this, SLOT(initialize()));
        return;
    }

    tgl_do_get_difference(gTLS, 0, 0, 0);
    Storage::instance()->updateUserInfo();
    Storage::instance()->updateChats();
    Storage::instance()->updateContacts();

    User* currentUser = (User*)Storage::instance()->getPeer(TGL_PEER_USER, gTLS->our_id);
    setContextProperty("_currentUser", currentUser);
}

void MainScreen::onAppFullScreen()
{
    m_appFullScreen = true;

    Notification::deleteAllFromInbox();
    Notification::clearEffectsForAll();
    m_notificationTimer.stop();
    m_notificationList.clear();
}

void MainScreen::onAppThumbnail()
{
    m_appFullScreen = false;

    m_notificationTimer.start(1000);
}

void MainScreen::showNotifications()
{
    foreach(Notification* n, m_notificationList)
    {
        n->notify();
    }

    m_notificationList.clear();
}

void MainScreen::onMessageReceived(const Message* message)
{
    if (!m_appFullScreen && !message->from()->muted())
    {
        Notification* notification = new Notification();
        notification->setType(NotificationType::Default);
        notification->setTitle("Telegram");
        notification->setBody("You have new message from " + message->from()->title());

        m_notificationList.append(notification);

        /*if (m_appFullScreen)
        notification->setSoundUrl(QUrl("asset:///sounds/sound_a.wav"));*/

        //notification->notify();

        /*if (m_appFullScreen)
        {
            notification->deleteFromInbox();
            notification->clearEffects();
        }*/
    }
}

bool MainScreen::contactExist(const QString& phone)
{
    PeerDataModel* contacts = Storage::instance()->contacts();

    QString phone_filtred(phone);
    phone_filtred.replace("+","");
    phone_filtred.replace(" ","");

    bool found = false;
    for (int i = 0; i < contacts->size(); i++)
    {
        User* contact = (User*)contacts->value(i);
        if (contact->phone() == phone_filtred)
        {
            found = true;
            break;
        }
    }

    return found;
}

void MainScreen::_createGroupCallback(struct tgl_state *TLS, void *callback_extra, int success, struct tgl_message *M)
{
    CreateGroupData* data = (CreateGroupData*)callback_extra;
    delete[] data->peers;

    GroupChat* groupChat = NULL;

    if (success)
    {
        groupChat = (GroupChat*)Storage::instance()->getPeer(TGL_PEER_CHAT, M->to_id.id);
        groupChat->setAdmin(gTLS->our_id);

        tgl_peer_id_t peer = {groupChat->type(), groupChat->id()};

        if (!data->chatPhoto.isEmpty())
            tgl_do_set_chat_photo(gTLS, peer, data->chatPhoto.toUtf8().data(), NULL, NULL);
    }

    delete data;

    emit m_instance->groupCreated(groupChat);
}

void MainScreen::_addMemberCallback(struct tgl_state *TLS, void *callback_extra, int success, struct tgl_message *M)
{
    if (!success)
        return;

    GroupChat* groupChat = (GroupChat*)Storage::instance()->getPeer(TGL_PEER_CHAT, M->to_id.id);
    groupChat->addMember((User*)callback_extra, TLS->our_id);
}

void MainScreen::_deleteMemberCallback(struct tgl_state *TLS, void *callback_extra, int success, struct tgl_message *M)
{
    if (!success)
        return;

    GroupChat* groupChat = (GroupChat*)Storage::instance()->getPeer(TGL_PEER_CHAT, M->to_id.id);
    groupChat->deleteMember((User*)callback_extra);
}

void MainScreen::_deleteSelfFromGroupCallback(struct tgl_state *TLS, void *callback_extra, int success, struct tgl_message *M)
{
    if (success)
    {
        User* currentUser = (User*)Storage::instance()->getPeer(TGL_PEER_USER, gTLS->our_id);
        GroupChat* groupChat = (GroupChat*)Storage::instance()->getPeer(TGL_PEER_CHAT, M->to_id.id);
        groupChat->deleteMember(currentUser);
    }
    Storage::instance()->deleteHistory((Peer*)callback_extra);
    Storage::instance()->deleteChat((Peer*)callback_extra);
}

void MainScreen::_contactAddHandler(struct tgl_state *TLS, void *callback_extra, int success, int size, struct tgl_user *users[])
{
    emit m_instance->contactAdded(size == 0, "Something wrong");
}

void MainScreen::_contactRenameHandler(struct tgl_state *TLS, void *callback_extra, int success, int size, struct tgl_user *users[])
{
    emit m_instance->contactRenamed(size == 0, "Somthing wrong");
}

void MainScreen::_contactDeleteHandler(struct tgl_state *TLS, void *callback_extra, int success)
{
    if (success)
    {
        tgl_peer_id_t peer;
        peer.type = ((User*)callback_extra)->type();
        peer.id = ((User*)callback_extra)->id();
        tgl_do_get_user_info(gTLS, peer, false, NULL, NULL);
        Storage::instance()->deleteContact((User*)callback_extra);
    }

    emit m_instance->contactDeleted(!success, "Something wrong");
}

void MainScreen::_broadcastSended(struct tgl_state *TLS, void *extra, int success, int num, struct tgl_message *ML[])
{
    BroadcastChat* chat = (BroadcastChat*)extra;
    if (success)
    {
        Message* message = new Message(ML[0]->id, ML[0]);
        message->setParent(Storage::instance());
        chat->addMessage(message);
    }
}

User* MainScreen::getUser(int id)
{
    return (User*)Storage::instance()->getPeer(TGL_PEER_USER, id);
}

QString MainScreen::getAppVersion() const
{
    bb::ApplicationInfo info;
    return info.version();
}
