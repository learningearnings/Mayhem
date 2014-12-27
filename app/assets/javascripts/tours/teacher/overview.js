var teacher_overview = {
  id: "teacher_overview",
  steps: [{
    target: document.querySelector('.home'),
    content: "Welcome to LE! Let us give you a quick tour and show you how to get started.",
    placement: "bottom",
    multipage: true,
    onNext: function() {
      window.location = "/teachers/bank"
    }
  }, {
    target: document.querySelector('.bank'),
    content: "The bank page is where you print LE credits and issue electronic LE credits.",
    placement: "bottom"
  }, {
    target: document.querySelector('.edit-credit-categories'),
    content: "When sending Credits electronically you can also attach a category, or reason for the award. Create and edit those here if you would like to use this feature.",
    placement: "top"
  }, {
    target: $('a[href=#print-credits]')[0],
    content: "Here you can create Credits that can be printed and given to your students.",
    placement: "top"
  }, {
    target: $('a[href=#electronic-credits]')[0],
    content: "You can also electronically send credits to any student or classroom of students you create.",
    placement: "top",
    multipage: true,
    onNext: function() {
      window.location = "/teachers/bulk_students"
    }
  }, {
    target: document.querySelector('.new-students-link'),
    content: "Click the new students button to add students. You may also upload a file to import students many students at one time.",
    placement: "right",
    multipage: true,
    onNext: function() {
      window.location = "/classrooms"
    }
  }, {
    target: document.querySelector('.classrooms'),
    content: "Create a Classroom first. This will allow you to find and give your students LE credits quickly.",
    placement: "bottom"
  }, {
    target: document.querySelector('.new_classroom'),
    content: "To create one, click here and just add the name you want it to have.",
    placement: "top",
    multipage: true,
    onNext: function() {
      window.location = "/store"
    }
  }, {
    target: document.querySelector('.shop'),
    content: "The Store is where you create and manage prizes or rewards for your classrooms. This page will show you all the rewards in your school.",
    placement: "bottom"
  }, {
    target: document.querySelector('.manage-rewards'),
    content: "You can add a new reward or update and existing one here.",
    placement: "left",
    multipage: true,
    onNext: function() {
      window.location = "/teachers/reports"
    }
  }, {
    target: document.querySelector('.reports'),
    content: "Run a Purchase Report to see what items your students have purchased from the store. You can also check student Credit balances or see who's logging in.",
    placement: "bottom"
  }]
}
