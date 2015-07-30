  var add_classroom_tour = {
    id: 'add-classroom-tour',
    steps: [
      {
        target: document.querySelector('.resp-page-content'),
        content: "This is where you add students to your classroom",
        placement: "top"
      },
      {
        target: document.querySelector('.btn.add-new-student'),
        content: "Click here to add a new student",
        placement: "top",
        showNextButton: false
      },
      {
        target: document.querySelector('#add-new-student-modal'),
        content: "This is where you will add a new student's information. Enter your student's information and click Add",
        placement: "left",
        showNextButton: false,
        onNext: function() {}
      },
      {
        target: document.querySelector('#classroom-students'),
        content: "The new user shows up in the table.",
        placement: "top"
      }
    ]
  }
