module Invitations
  class BulkSendService
    def initialize(event:, user:, guest_ids: nil, channel: :email)
      @event = event
      @user = user
      @guest_ids = guest_ids
      @channel = channel.to_sym
    end

    def call
      guests = scoped_guests
      return failure(["No guests found to invite"]) if guests.empty?

      results = { sent: 0, failed: 0, errors: [] }

      guests.find_each do |guest|
        result = Invitations::SendService.new(guest: guest, user: user, channel: channel).call
        if result[:success]
          results[:sent] += 1
        else
          results[:failed] += 1
          results[:errors] << "#{guest.full_name}: #{result[:errors].join(', ')}"
        end
      end

      { success: true, results: results }
    end

    private

    attr_reader :event, :user, :guest_ids, :channel

    def scoped_guests
      scope = event.guests
      scope = scope.where(id: guest_ids) if guest_ids.present?
      scope
    end

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
