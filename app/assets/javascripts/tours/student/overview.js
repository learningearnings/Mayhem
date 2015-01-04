var student_overview = {
  id: "student_overview",
  steps: [{
    target: document.querySelector('.home'),
    content: "Welcome to LE! On the Home page you will find messages about new features and reward highlights.",
    placement: "bottom",
    multipage: true,
    onNext: function() {
      window.location = "/inbox/teacher_messages"
    }
  }, {
    target: $('.inbox_with_count')[0],
    content: "If your teacher sends you an electronic credit, you will receive a message below. You can deposit electronic credits by clicking on the Claim Credits link in the message.",
    placement: "bottom",
    multipage: true,
    onNext: function() {
      window.location = "/bank"
    }
  }, {
    target: document.querySelector('.bank'),
    content: "Bank page is where you deposit and save your hard earned Credits.",
    placement: "bottom"
  }, {
    target: $('a[href=#enter-codes-modal]')[0],
    content: "If you received a printed Credit use this button to enter the code and deposit your Credits.",
    placement: "bottom"
  }, {
    target: document.querySelector('.pending-credits'),
    content: "You can also look at your checking history to see what has been deposited and purchased.",
    placement: "top",
    multipage: true,
    onNext: function() {
      window.location = "/store"
    }
  }, {
    target: document.querySelector('.shop'),
    content: "The shopping page displays all of the rewards in your school's store. Just click on a reward to make a purchase.",
    placement: "bottom"
  }]
}
