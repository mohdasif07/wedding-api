module Api
  module V1
    class AlbumsController < BaseController
      before_action :set_album, only: %i[show update destroy]
      before_action -> { authorize_admin! }, only: %i[create update destroy]

      def index
        scope = scoped_albums.search(params[:q])
        records = paginate(scope.order(created_at: :desc))

        render json: AlbumBlueprint.render_as_hash(records)
      end

      def show
        render json: AlbumBlueprint.render_as_hash(@album, serializer_options.merge(view: :detailed))
      end

      def create
        album = current_user.albums.build(album_params)
        if album.save
          render json: AlbumBlueprint.render_as_hash(album), status: :created
        else
          render_errors(album.errors.full_messages)
        end
      end

      def update
        if @album.update(album_params)
          render json: AlbumBlueprint.render_as_hash(@album)
        else
          render_errors(@album.errors.full_messages)
        end
      end

      def destroy
        @album.destroy!
        head :no_content
      end

      private

      def set_album
        @album = scoped_albums.find(params[:id])
      end

      def scoped_albums
        super
      end

      def album_params
        params.permit(:title, :description)
      end
    end
  end
end
