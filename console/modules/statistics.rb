# frozen_string_literal: true

module Statistics
  def statistics
    decorate_data.sort_by { |object| [object[:attempts_total], object[:attempts_used], object[:hints_used]] }
  end

  def decorate_data
    load_data.each_with_object([]) do |object, array|
      array << {
        name: object.user.name, difficulty: object.difficulty,
        attempts_total: object.attempts, attempts_used: object.attempts_used,
        hints_total: object.number_of_hints, hints_used: object.hints_used
      }
    end
  end

  def load_data
    Codebreaker::Game.load
  end
end
