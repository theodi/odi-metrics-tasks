class DiversityMetrics

  @queue = :metrics

  extend MetricsHelper
  extend GoogleDriveHelper

  def self.perform
    {
      "diversity-gender" => gender
    }.each_pair do |metric, value|
      store_metric metric, DateTime.now, value
    end
  end

  def self.gender
    gender_sheet = metrics_worksheet("diversity", "Gender")
    genders = {}
    (3..99).each do |row|
      gender = gender_sheet["C#{row}"]
      if gender.present? && gender != 'Total'
        genders[gender.downcase] = row
      else
        break
      end
    end
    data = {
      "total" => {},
      "teams" => {}
    }
    genders.each_pair do |gender, row|
      data["total"][gender] = gender_sheet["D#{row}"].to_i
    end
    ("E".."Z").each do |col|
      title = gender_sheet["#{col}2"].downcase.gsub(' ','_')
      if title != ""
        data["teams"][title] = {}
        genders.each_pair do |gender, row|
          data["teams"][title][gender] = gender_sheet["#{col}#{row}"].to_i
        end
      end
    end
    data
  end

end
