var school_admin_overview = {
  id: 'school_admin_overview',
  steps: [{
    target: document.querySelector('.home'),
    content: "Welcome to LE! Let us give you a quick tour and get you setup so you can start using LE. This tour can be restarted from the Help page if needed.",
    placement: 'bottom',
    multipage: true,
    onNext: function() {
      window.location = "/classrooms"
    }
  }, {
    target: document.querySelector('.new_classroom'),
    content: "First, let's create a classroom. This can be a test classroom if you like, you can always delete it later.",
    placement: "bottom",
    showNextButton: false
  }, {
    target: document.querySelector('#classrooms'),
    content: "Now that have you a classroom, click the name here and we can add students to it.",
    placement: "left",
    showNextButton: false,
    multipage: true
  }, {
    target: document.querySelector('.btn.add-new-student'),
    content: "Let's add a new student now and they will automatically be added to your new classroom.",
    placement: "top",
    showNextButton: false,
    nextOnTargetClick: true
  }, {
    target: document.querySelector('#add-new-student-modal'),
    content: "Enter your new student's information. If you like you can create a fictional student and delete the account later or you can use a real student.",
    placement: "left",
    showNextButton: false
  }, {
    target: document.querySelector('#classroom-students'),
    content: "The new student you created now shows up in classroom roster list.  Now, let's take a look at some of the things we can do with a classroom.",
    placement: "top",
    multipage: true,
    onNext: function() {
      window.location = "/school_admins/bank"
    }
  }, {
    target: document.querySelector('.bank'),
    content: "The Bank page is where you manage your LE Credits. Credits are LE's currency or points.  You will give your students LE Credits for reaching goals, doing good or any other criteria you set.",
    placement: "bottom"
  }, {
    target: $('a[href=#print-credits]')[0],
    content: "The Print Credits tab allows you to print LE Credits that have codes on them allowing students to deposit them into their account. Just tell LE how many of each of the denominations and a file will be created you can print.",
    placement: "top",
    onShow: function() {
      $('a[href=#print-credits]').click();
    }
  }, {
    target: $('a[href=#electronic-credits]')[0],
    content: "The Electronic Credits tab allows you to send credits to a single student, or one of your classrooms. The student will receive a system message allowing them to deposit the credits.",
    placement: "top",
    onShow: function() {
      $('a[href=#electronic-credits]').click();
    }
  }, {
    target: $('a[href=#transfer-credits]')[0],
    content: "As an LE Admin, you can also tranfer credits from one teacher to another.",
    placement: "top",
    onShow: function() {
      $('a[href=#transfer-credits]').click();
    }
  }, {
    target: document.querySelector('#classroom_id'),
    content: "Start by selecting the classroom we created earlier.",
    placement: "right"
  }, {
    target: document.querySelector('.class_points'),
    content: "This is where you enter the number of LE Credits. Below, you'll notice that the number of credits you enter will be populated. You'll still be able to update each student's credits individually to increase or even exclude a student from receving any.",
    placement: "right"
  }, {
    target: document.querySelector('#classroom_otu_code_category'),
    content: "You can also create categories, or goals to use with e-Credits. This will tell the student 'why' they recieved credits from you. This is optional, so we won't set any up right now.",
    placement: "right",

  }, {
    target: document.querySelector('.electronic-credits-for-classroom input[type=submit]'),
    content: "Once you are finished setting up the credits for the classroom, you can click this button to send those credits to the students.",
    placement: "right",
    showNextButton: false,
    multipage: true,
    nextOnTargetClick: true
  }, {
    target: document.querySelector('.alert'),
    content: "Great! Our credits have been sent. Now let's create a reward so they'll have a reason to earn more credits from you!",
    placement: "right",
    multipage: true,
    onNext: function() {
      window.location = "/store"
    }
  }, {
    target: document.querySelector('.shop'),
    content: "The shop page is where you can add and manage rewards that are in your store.",
    placement: "bottom"
  }, {
    target: document.querySelector('.manage-rewards'),
    content: "Click this button and lets get started creating a reward.",
    placement: "left",
    showNextButton: false,
    nextOnTargetClick: true,
    multipage: true
  }, {
    target: document.querySelector('.create-reward'),
    content: "You can edit any rewards you already created on this page. Let's click here to create a new reward.",
    placement: "left",
    multipage: true,
    showNextButton: false,
    nextOnTargetClick: true
  }, {
    target: document.querySelector('.custom-reward-button'),
    content: "Below we show you hundreds of rewards that have been created by great teachers like you.  Feel free to use their ideas, or create a brand new one of your own.  Click here and we'll show you how easy it is to do that.",
    placement: "right",
    multipage: true,
    showNextButton: false,
    nextOnTargetClick: true
  }, {
    target: document.querySelector('.full-content'),
    content: "Just fill in the information about your new reward. Let's create a test reward and click the Create Reward link when finished.",
    multipage: true,
    placement: "top",
    showNextButton: false,
    nextOnTargetClick: document.querySelector('input[type=submit]')
  }, {
    target: document.querySelector('.resp-product-row'),
    content: "Now you have a reward that your students will see and can purchase when they login! Let's continue on to our last stop, the reports page.",
    multipage: true,
    placement: "top",
    onNext: function() {
      window.location = "/school_admins/reports"
    }
  }, {
    target: document.querySelector('.reports'),
    content: "The Purchase Report is how you can see what rewards your students have purchased from the store. Other reports allow you to check student balances or see who's logging in.  We hope you enjoy using LE, you can also restart this tour or find other answers using the Help page.",
    placement: "bottom"
  }]
}
