class DocsController < ApplicationController
  def index
    userprofileId = params[:user_profile_id]
    @user_profile = UserProfile.find(userprofileId)
    @docs = @user_profile.docs.all
  end

  def edit
    userprofileId = params[:user_profile_id]
    @user_profile = UserProfile.find(userprofileId)
    @doc = Doc.find(params[:id])
  end

  def new
    userprofileId = params[:user_profile_id]
    @user_profile = UserProfile.find(userprofileId)
    @doc = Doc.new
  end

  def create
    userprofileId = params[:user_profile_id]
    @user_profile = UserProfile.find(userprofileId)
    @doc = Doc.new(doc_params)
    uploadedDoc = params[:doc][:documents]
    if uploadedDoc != nil
      t = Time.now
      ext = File.extname(uploadedDoc.original_filename)
      savename = "file_#{t.strftime("%Y%m%d%H%M")}" + ext
      @doc.filename = uploadedDoc.original_filename
      @doc.savefilename = savename
      @doc.user_profile = @user_profile

      savepath = Rails.root.join('public','documents', savename)

      File.open(savepath,'wb') do |file|
        file.write(uploadedDoc.read)
      end 
    end
    if @doc.save
      redirect_to user_profile_docs_path(@user_profile)
    else
      render :new
    end
  end

  def update
    userprofileId = params[:user_profile_id]
    @user_profile = UserProfile.find(userprofileId)
    @doc = Doc.find(params[:id])
    if @doc.update(doc_params)
      redirect_to user_profile_docs_path(@user_profile)
    else
      render :edit
    end
  end

  def destroy
    userprofileId = params[:user_profile_id]
    @user_profile = UserProfile.find(userprofileId)
    id = params[:id]
    doc = Doc.find(id)
    if doc != nil
      filename = Rails.root.join('public','documents',doc.savefilename)
      File.delete(filename) if File.exist?(filename)
      doc.destroy
    end
    redirect_to user_profile_docs_path(@user_profile)
  end

  def download
    userprofileId = params[:user_profile_id]
    @user_profile = UserProfile.find(userprofileId)
    @doc = Doc.find(params[:id])
    savepath = Rails.root.join('public','documents', @doc.savefilename)
    send_file savepath,
            :filename => @doc.filename,
            :type => 'application/octet-stream',
            :disposition => 'attachment'
    flash[:notice] = "Your file has been downloaded"
  end

  private

  def doc_params
    params.require(:doc).permit(:description)
  end
end
