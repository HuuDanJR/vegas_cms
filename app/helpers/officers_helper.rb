module OfficersHelper
  def status_str(warning_id)
    status_labels = { 1 => 'Còn sống', 2 => 'Đã mất', 3 => 'Mất tích' }
    status_labels[warning_id]
  end
end
