class AddTimerexSettingsToActiveTimes < ActiveRecord::Migration[7.2]
  def change
    add_column :active_times, :display_start_time, :time
    add_column :active_times, :display_end_time, :time
    add_column :active_times, :timerex_enabled, :boolean, default: true, null: false

    reversible do |dir|
      dir.up do
        ActiveTime.update_all("display_start_time = start_time, display_end_time = end_time, timerex_enabled = TRUE")
      end
    end
  end
end
