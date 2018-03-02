require 'rails_helper'

describe MailingLists::Create do

  describe 'valid creation' do
    context 'with valid params' do
      let(:result) { described_class.(mailing_list: attributes_for(:mailing_list_tb)) }

      it 'should be persisted' do
        # Stub LDAP::Update on MailingLists creation
        stub_operation(LDAP::Create)

        expect(result.success?).to be true
        expect(result['model'].persisted?).to be true
      end
    end
  end

  describe 'invalid creation' do
    context 'when name is empty' do
      let(:result) { described_class.(mailing_list: attributes_for(:mailing_list_tb, name: '')) }

      it 'should not be persisted' do
        expect(result['contract.default'].errors.messages).to eq({
          name: ["doit être rempli(e)", "n'est pas valide"],
        })
      end
    end

    context 'when name is not an email' do
      let(:result) { described_class.(mailing_list: attributes_for(:mailing_list_tb, name: 'foo')) }

      it 'should not be persisted' do
        expect(result['contract.default'].errors.messages).to eq({
          name: ["n'est pas valide"],
        })
      end
    end

    context 'when name is already taken' do
      before {
        # Stub LDAP::Update on MailingLists creation
        stub_operation(LDAP::Create)

        described_class.(mailing_list: attributes_for(:mailing_list_tb, name: 'foo@foo.com'))
      }

      let(:result) { described_class.(mailing_list: attributes_for(:mailing_list_tb, name: 'foo@foo.com')) }

      it 'should not be persisted' do
        expect(result['contract.default'].errors.messages).to eq({
          name: ["n'est pas disponible"],
        })
      end
    end

    context 'when emails attributes are empty' do
      let(:result) { described_class.(mailing_list: attributes_for(:mailing_list, name: 'foo@foo.com')) }

      it 'should not be persisted' do
        expect(result['contract.default'].errors.messages).to eq({
          "emails.email": ["doit être rempli(e)", "n'est pas valide"],
          "emails.first_name": ["doit être rempli(e)"],
          "emails.last_name": ["doit être rempli(e)"],
        })
      end
    end

    context 'when email.first_name is empty' do
      let(:result) { described_class.(mailing_list: attributes_for(:mailing_list, name: 'foo@foo.com').merge(emails_attributes: { '0' => { last_name: Faker::Name.last_name, email: Faker::Internet.email } })) }

      it 'should not be persisted' do
        expect(result['contract.default'].errors.messages).to eq({
          "emails.first_name": ["doit être rempli(e)"],
        })
      end
    end

    context 'when email.last_name is empty' do
      let(:result) { described_class.(mailing_list: attributes_for(:mailing_list, name: 'foo@foo.com').merge(emails_attributes: { '0' => { first_name: Faker::Name.first_name, email: Faker::Internet.email } })) }

      it 'should not be persisted' do
        expect(result['contract.default'].errors.messages).to eq({
          "emails.last_name": ["doit être rempli(e)"],
        })
      end
    end

    context 'when email.email is empty' do
      let(:result) { described_class.(mailing_list: attributes_for(:mailing_list, name: 'foo@foo.com').merge(emails_attributes: { '0' => { first_name: Faker::Name.first_name, last_name: Faker::Name.last_name } })) }

      it 'should not be persisted' do
        expect(result['contract.default'].errors.messages).to eq({
          "emails.email": ["doit être rempli(e)", "n'est pas valide"],
        })
      end
    end

    INVALID_MAIL_ADDRESSES.each do |email|
      context 'when email.email is invalid' do
        let(:result) { described_class.(mailing_list: attributes_for(:mailing_list, name: 'foo@foo.com').merge(emails_attributes: { '0' => { first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: email } })) }

        it 'should not be persisted' do
          expect(result['contract.default'].errors.messages).to eq({
            "emails.email": ["n'est pas valide"],
          })
        end
      end
    end

  end

end
