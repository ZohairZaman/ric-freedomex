# encoding: UTF-8
# frozen_string_literal: true

# TODO: Replace TXOUT with composite TXID.

module Worker
  class DepositCoin

    def process(payload)
      payload.symbolize_keys!
      ccy = Currency.find(payload.fetch(:currency))
      tx  = ccy.api.load_deposit(payload.fetch(:txid))

      if tx
        Rails.logger.info { "Processing #{ccy.code.upcase} deposit: #{payload.fetch(:txid)}." }
        ActiveRecord::Base.transaction do
          tx.fetch(:entries).each_with_index { |entry, index| deposit!(ccy, tx, entry, index) }
        end
      else
        Rails.logger.info { "Could not load #{ccy.code.upcase} deposit: #{payload.fetch(:txid)}." }
      end
    end

  private
 
    def deposit!(currency, tx, entry, index)
      unless deposit_entry_processable?(currency, tx, entry, index)
        return Rails.logger.info { "Already processed! Skipping #{tx.fetch(:id)}:#{index}." }         
      end

      deposit = "deposits/#{currency.type}".camelize.constantize.create! \
        txid:          tx[:id],
        txout:         index,
        address:       entry[:address],
        amount:        entry[:amount],
        member:        PaymentAddress.where(currency: currency, address: entry[:address]).first.account.member,
        currency:      currency,
        confirmations: tx[:confirmations]

      deposit.with_lock do
        if currency.deposit_confirmations > 0 && deposit.confirmations >= currency.deposit_confirmations
          deposit.accept!
        end
      end

      Rails.logger.info { "Successfully processed #{tx.fetch(:id)}:#{index}." }
    rescue => e
      Rails.logger.error { "Failed to process #{tx.fetch(:id)}:#{index}." }
      Rails.logger.debug { tx.inspect }
      report_exception(e)
    end

    def deposit_entry_processable?(currency, tx, entry, index)
      PaymentAddress.where(currency: currency, address: entry[:address]).exists? &&
        !Deposit.where(currency: currency, txid: tx[:id], txout: index).exists?
    end
  end
end
