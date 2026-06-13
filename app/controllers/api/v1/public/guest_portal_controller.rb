module Api
  module V1
    module Public
      class GuestPortalController < ApplicationController
        def show
          guest = Guest.find_by!(qr_code_token: params[:token])
          event = guest.event

          render json: {
            guest: GuestBlueprint.render_as_hash(guest),
            event: {
              id: event.id,
              title: event.title,
              venue: event.venue,
              event_date: event.event_date,
              start_time: event.start_time,
              end_time: event.end_time
            }
          }
        end

        def update_rsvp
          guest = Guest.find_by!(qr_code_token: params[:token])
          status = params[:status].to_s

          unless Guest.rsvp_statuses.key?(status)
            return render_errors(["Invalid RSVP status"])
          end

          rsvp = guest.rsvps.find_or_initialize_by(event: guest.event)
          rsvp.status = status

          if rsvp.save
            render json: GuestBlueprint.render_as_hash(guest.reload)
          else
            render_errors(rsvp.errors.full_messages)
          end
        end
      end
    end
  end
end
