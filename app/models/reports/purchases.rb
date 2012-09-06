module Reports
  class Purchases < Reports::Base
    def execute!
      20.times do
        @data << fake_row
      end
    end

    def fake_row
      Reports::Row[
        delivery_teacher: "Foo",
        classroom: "",
        student: "bar",
        grade: 6,
        purchased: "01/14/1983",
        reward: "Boogers",
        status: "Stock"
      ]
    end

    def headers
      {
        delivery_teacher: "Delivery Teacher",
        classroom: "Classroom",
        student: "Student (username)",
        grade: "Grade",
        purchased: "Purchased",
        reward: "Reward",
        status: "Status"
      }
    end
  end
end
