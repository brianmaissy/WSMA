module HousesHelper

  def permanent_chores_start_week_options
    (1..15).collect {|i|[i,i]}
  end

  def using_online_sign_off_options
    [['Yes', 1], ['No', 0]]
  end

  def sign_off_verification_mode_options
    [["None", 0], ["Without password", 1], ["With password", 2]]
  end

end
