module Api
  module V1
    class OtpController < BaseController
      def send_code
        phone_number = params[:phone_number]

        unless phone_number.present? && phone_number.match?(/\A(\+92\d{10}|0\d{10})\z/)
          return render json: { error: "Valid Pakistan phone number is required" }, status: :unprocessable_entity
        end

        OtpService.generate(phone_number, email: current_user.email)
        render json: { message: "OTP sent to your email" }
      end

      def verify
        phone_number = params[:phone_number]
        code = params[:code]

        unless phone_number.present? && code.present?
          return render json: { error: "Phone number and code are required" }, status: :unprocessable_entity
        end

        if OtpService.verify(phone_number, code)
          current_user.update!(phone: phone_number, phone_verified: true)
          render json: { verified: true, message: "Phone number verified successfully" }
        else
          render json: { verified: false, error: "Invalid or expired OTP code" }, status: :unprocessable_entity
        end
      end
    end
  end
end
