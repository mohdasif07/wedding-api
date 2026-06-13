module Api
  module V1
    class PhotosController < BaseController
      before_action -> { authorize_admin! }, only: %i[create destroy]

      def index
        scope = Photo.all
        scope = scope.for_event(params[:event_id])
        scope = scope.for_album(params[:album_id])
        records = paginate(scope.order(created_at: :desc))

        render json: PhotoBlueprint.render_as_hash(records, serializer_options)
      end

      def show
        photo = Photo.find(params[:id])
        render json: PhotoBlueprint.render_as_hash(photo, serializer_options)
      end

      def create
        photo = Photo.new(photo_attributes)

        unless attach_uploaded_image(photo)
          return render_errors(photo.errors.full_messages)
        end

        if photo.save
          render json: PhotoBlueprint.render_as_hash(photo, serializer_options), status: :created
        else
          render_errors(photo.errors.full_messages)
        end
      end

      def destroy
        photo = Photo.find(params[:id])
        photo.destroy!
        head :no_content
      end

      private

      def photo_attributes
        params.permit(:caption, :event_id, :album_id)
      end

      def uploaded_file
        params.permit(:image)[:image]
      end

      def attach_uploaded_image(photo)
        file = uploaded_file

        if file.blank?
          photo.errors.add(:image, "can't be blank")
          return false
        end

        unless file.is_a?(ActionDispatch::Http::UploadedFile)
          photo.errors.add(:image, "must be a valid file upload")
          return false
        end

        photo.image.attach(file)
        true
      end
    end
  end
end
