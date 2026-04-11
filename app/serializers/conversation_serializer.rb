class ConversationSerializer < ActiveModel::Serializer
  attributes :id, :participant_id, :participant_name, :participant_avatar,
             :last_message, :time, :unread, :online, :trip_context

  def id
    object.id.to_s
  end

  def participant_id
    other_user&.id&.to_s
  end

  def participant_name
    other_user&.name
  end

  def participant_avatar
    return nil unless other_user&.avatar&.attached?
    Rails.application.routes.url_helpers.url_for(other_user.avatar)
  rescue StandardError
    nil
  end

  def last_message
    object.last_message&.body
  end

  def time
    msg = object.last_message
    return nil unless msg
    time_ago_in_words(msg.created_at)
  end

  def unread
    object.unread_count_for(current_user)
  end

  def online
    other_user&.online || false
  end

  def trip_context
    object.trip&.title
  end

  private

  def other_user
    @other_user ||= object.participants.where.not(id: current_user.id).first
  end

  def current_user
    instance_options[:current_user]
  end

  def time_ago_in_words(time)
    return nil unless time
    seconds = (Time.current - time).to_i
    case seconds
    when 0..59 then "#{seconds}s ago"
    when 60..3599 then "#{seconds / 60}m ago"
    when 3600..86399 then "#{seconds / 3600}h ago"
    else "#{seconds / 86400}d ago"
    end
  end
end
