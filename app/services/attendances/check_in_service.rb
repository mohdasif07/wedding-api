module Attendances
  class CheckInService
    def initialize(qr_code_token:, event_id:)
      @qr_code_token = qr_code_token
      @event_id = event_id
    end

    def call
      guest = Guest.find_by(qr_code_token: qr_code_token, event_id: event_id)
      return failure(["Guest not found for this event"]) unless guest

      attendance = Attendance.find_or_initialize_by(guest: guest, event_id: event_id)
      if attendance.persisted?
        return success(attendance, already_checked_in: true)
      end

      attendance.checked_in_at = Time.current
      return failure(attendance.errors.full_messages) unless attendance.save

      success(attendance)
    end

    private

    attr_reader :qr_code_token, :event_id

    def success(attendance, already_checked_in: false)
      { success: true, attendance: attendance, already_checked_in: already_checked_in }
    end

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
