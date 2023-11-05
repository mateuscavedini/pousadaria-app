module GuesthouseHelper
  def guesthouse_allow_pets_string(guesthouse)
    str = 'Esta pousada '
    str << 'não ' unless guesthouse.allow_pets?
    str << 'permite pets'
  end

  def guesthouse_format_time(time)
    time.strftime('%H:%M')
  end
end