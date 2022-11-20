module ApplicationHelper
  def table_tr_color(status)
    case status
    when 'created' then 'warning'
    when 'started' then 'info'
    when 'finished' then 'success'
    end
  end
end
