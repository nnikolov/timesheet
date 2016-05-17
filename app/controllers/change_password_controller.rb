class ChangePasswordController < ApplicationController
  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @logged_in.change_password(employee_params)
        format.html { redirect_to change_password_show_path, notice: 'Password was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def employee_params
    params.require(:employee).permit(:current_password, :new_password, :confirm_password)
  end
end
