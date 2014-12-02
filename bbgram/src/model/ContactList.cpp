#include "ContactList.h"

#include <bb/pim/contacts/ContactService>
#include <bb/pim/contacts/Contact>
#include <bb/pim/contacts/ContactBuilder>
#include <bb/pim/contacts/ContactAttributeBuilder>

using namespace bb::cascades;
using namespace bb::pim::contacts;

ContactList::ContactList(QListDataModel<User*>* telegramContacts)
    : m_filter(3), m_telegramContacts(telegramContacts)
{
    m_model = new GroupDataModel(this);
    m_model->setSortingKeys(QStringList() << "sortingKey" << "firstName");

    connect(m_telegramContacts, SIGNAL(itemAdded(QVariantList)), SLOT(updateContent()));
    //connect(m_telegramContacts, SIGNAL(itemMoved(QVariantList, QVariantList)), SLOT(updateContent()));
    connect(m_telegramContacts, SIGNAL(itemRemoved(QVariantList)), SLOT(updateContent()));
    connect(m_telegramContacts, SIGNAL(itemUpdated(QVariantList)), SLOT(updateContent()));
    connect(this, SIGNAL(filterChanged()), SLOT(updateContent()));

    updatePhonebook();
    updateContent();
}

ContactList::~ContactList()
{
}

GroupDataModel* ContactList::model() const
{
    return m_model;
}

void ContactList::updatePhonebook()
{
    ContactService service;
    ContactListFilters filter;

    QSet<AttributeKind::Type> attrs;
    attrs.insert(AttributeKind::Name);
    attrs.insert(AttributeKind::Phone);

    filter.setHasAttribute(attrs);
    QList<Contact> phonebook = service.contacts(filter);

    mPhoneBook.clear();

    Contact contact;
    foreach (contact, phonebook)
    {
        QList<ContactAttribute> phoneNumber = contact.phoneNumbers();

        QVariantMap entry;
        entry["sortingKey"] = contact.firstName();
        entry["firstName"] = contact.firstName();
        entry["lastName"] = contact.lastName();
        entry["online"] = true;
        if(!phoneNumber.empty())
            entry["phone"] = phoneNumber[0].value();
        mPhoneBook.push_back(entry);
    }
}

int ContactList::filter() const
{
    return m_filter;
}

void ContactList::setFilter(int filter)
{
    m_filter = filter;
    emit filterChanged();
}

void ContactList::updateContent()
{
    m_model->clear();
    if (m_filter & 1)
    {
        for (int i = 0; i < m_telegramContacts->size(); i++)
        {
            User* user = m_telegramContacts->value(i);
            m_model->insert(user);
        }
    }

    if (m_filter & 2)
    {
        QVariantMap contact;
        foreach (contact, mPhoneBook)
        {
            m_model->insert(contact);
        }
    }
}
