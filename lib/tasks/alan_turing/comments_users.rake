require "csv"

namespace :db do
  desc "Import data from the CSV files"
  task alan_turing_comment_users: :environment do

    puts "Asigning Users to Comments"
    csv_file = "lib/tasks/alan_turing/comments_with_users.csv"
    CSV.foreach(csv_file, col_sep: ";", headers: true) do |line|
      attributes = line.to_hash
      comment = Comment.find_by(id: attributes["comment"].to_i)
      if comment.present?
        if attributes["usernumber"].present?
          attributes["usernumber"] = attributes["usernumber"].to_i
          unless User.find_by(id: attributes["usernumber"])
            User.create!(id: attributes["usernumber"],
                       username: "usuario_#{attributes["usernumber"]}",
                       email: "usuario_#{attributes["usernumber"]}@consul.dev",
                       password: "12345678",
                       password_confirmation: "12345678",
                       confirmed_at: Time.current,
                       terms_of_service: "1")
          end
          unless comment.user_id == attributes["usernumber"]
            comment.update_columns(user_id: attributes["usernumber"])
            print "." if (comment.id % 100) == 0
          end
        end
      end
    end
    puts "\nUsers assigned to Comments!"
  end
end
