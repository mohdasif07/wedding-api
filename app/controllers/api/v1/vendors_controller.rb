module Api
  module V1
    class VendorsController < BaseController
      before_action :set_vendor, only: %i[show update destroy]
      before_action -> { authorize_admin! }, only: %i[create update destroy]

      def index
        scope = scoped_vendors.search(params[:q]).by_type(params[:vendor_type])
        records = paginate(scope.order(:vendor_name))

        render json: VendorBlueprint.render_as_hash(records)
      end

      def show
        render json: VendorBlueprint.render_as_hash(@vendor)
      end

      def create
        vendor = current_user.vendors.build(vendor_params)
        if vendor.save
          render json: VendorBlueprint.render_as_hash(vendor), status: :created
        else
          render_errors(vendor.errors.full_messages)
        end
      end

      def update
        if @vendor.update(vendor_params)
          render json: VendorBlueprint.render_as_hash(@vendor)
        else
          render_errors(@vendor.errors.full_messages)
        end
      end

      def destroy
        @vendor.destroy!
        head :no_content
      end

      private

      def set_vendor
        @vendor = scoped_vendors.find(params[:id])
      end

      def scoped_vendors
        super
      end

      def vendor_params
        params.permit(
          :vendor_name, :vendor_type, :contact_person, :phone, :email,
          :contract_amount, :paid_amount, :notes
        )
      end
    end
  end
end
