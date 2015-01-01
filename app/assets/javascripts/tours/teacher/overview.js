var teacher_overview = {
  id: 'teacher_overview',
  steps: [{
    target: document.querySelector('.home'),
    content: "Welcome to LE! Let us give you a quick tour and get you setup so we you can start using LE.",
    placement: 'bottom',
    multipage: true,
    onNext: function() {
      window.location = "/classrooms"
    }
  }, {
    target: document.querySelector('.classrooms'),
    content: "Classrooms allow you to create groups of students so you can quickly find them to give credits and create rewards just for them.",
    placement: "bottom"
  }, {
    target: document.querySelector('.new_classroom'),
    content: "To start, simply type a classroom name and click Create.  Let's go ahead and create one now, you can always delete it later if you like.",
    placement: "bottom",
    showNextButton: false
  }, {
    target: document.querySelector('#classrooms'),
    content: "Now that have you a classroom, just click its name and we can add students to it.",
    placement: "left",
    showNextButton: false,
    multipage: true
  }, {
    target: document.querySelector('.resp-page-content'),
    content: "Here we can add new student since you don't already have one, but in the future you can also add existing students to a classroom.  Students can be in many classrooms, and you can create as many classrooms as you like.",
    placement: "top"
  }, {
    target: document.querySelector('.btn.add-new-student'),
    content: "Let's go ahead and create a new student, click here.",
    placement: "top",
    showNextButton: false,
    nextOnTargetClick: true
  }, {
    target: document.querySelector('#add-new-student-modal'),
    content: "This is where you will add your new student's information. If you like you can create a fictional student and delete the account later or you can add a real student.",
    placement: "left",
    showNextButton: false
  }, {
    target: document.querySelector('#classroom-students'),
    content: "The new student you created now shows up in classroom roster list.  Now, let's take a look at some of the things we can do with a classroom.",
    placement: "top",
    multipage: true,
    onNext: function() {
      window.location = "/teachers/bank"
    }
  }, {
    target: document.querySelector('.bank'),
    content: "The Bank page is where you manage your LE credits. Credits are LE's points or currency.  You will give your students LE Credits for reaching goals, doing good or any other criteria you set.",
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
    target: $('a[href=#lookup-code]')[0],
    content: "The Lookup A Code tab allows you to lookup a printed credit to see details about it. From here you can tell if it was redeemed, the date it was redeemed (if applicable), and the amount.",
    placement: "top",
    onShow: function() {
      $('a[href=#lookup-code]').click();
    }
  }, {
    target: $('a[href=#electronic-credits]')[0],
    content: "Now that you have an overviiew of what's possible, let's give some credits to your newly created classroom.",
    placement: "top",
    onShow: function() {
      $('a[href=#electronic-credits]').click();
    }
  }, {
    target: document.querySelector('.electronic-credits-for-classroom'),
    content: "This is section of the Bank is where you will issue credits on a classroom level.",
    placement: "top"
  }, {
    target: document.querySelector('#classroom_id'),
    content: "Start by selecting the classroom we created earlier.",
    placement: "right"
  }, {
    target: document.querySelector('.class_points'),
    content: "This is where you enter the number of LE credits. Below, you'll notice that the number of credits you enter will be populated. You'll still be able to update each student's credits individually to increase or even exclude a student from receving any.",
    placement: "right"
  }, {
    target: document.querySelector('#classroom_otu_code_category'),
    content: "You can also create categories, or goals to use with e-Credits. This will tell the student 'why' the recieved credits from you. This is optional, so we won't set any up right now.",
    placement: "right"
  }, {
    target: document.querySelector('.electronic-credits-for-classroom input[type=submit]'),
    content: "Once you are finished setting up the credits for the classroom, you can click this button to send those credits to the students.",
    placement: "right",
    showNextButton: false,
    multipage: true,
    nextOnTargetClick: true
  }, {
    target: document.querySelector('.alert'),
    content: "Sweet! Our credits have been sent. Now let's create a reward so they'll have a reason to earn more credits from you!",
    placement: "right",
    multipage: true,
    onNext: function() {
      window.location = "/store"
    }
  }, {
    target: document.querySelector('.shop'),
    content: "The shop page is where you can view and manage rewards that are in your store.",
    placement: "bottom"
  }, {
    target: document.querySelector('.manage-rewards'),
    content: "Click this link and lets get started creating that reward.",
    placement: "left",
    showNextButton: false,
    nextOnTargetClick: true
    multipage: true
  }, {
    target: document.querySelector('.create-reward'),
    content: "If you had existing rewards, they would show up below can you edit or delete one if you wanted. For now, click here to create a new reward.",
    placement: "left",
    multipage: true,
    showNextButton: false,
    nextOnTargetClick: true
  }, {
    target: document.querySelector('.full-content'),
    content: "From here, we can choose to create a custom reward, or choose from a large selection of existing templates.",
    placement: "top"
  }, {
    target: document.querySelector('.custom-reward-button'),
    content: "Below we show you hundreds of rewards that have been created over the years from great teachers like you.  Feel free to use their great ideas, or create a brand new one of your own.  Click here and we'll show you how easy it is to do that.",
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
    content: "Now you have a reward that your students will see in their store.  It will also show up in your list of rewards that you can manage (edit, or delete). That's all there is to creating and managing rewards. Let's continue on to our last stop, the reports page.",
    multipage: true,
    placement: "top",
    onNext: function() {
      window.location = "/teachers/reports"
    }
  }, {
    target: document.querySelector('.reports'),
    content: "The Purchase Report is how you can see what rewards your students have purchased from the store. Other reports allow you too check student balances or see who's logging in.  We hope you enjoy using LE, you can also restart this tour or find other answers using the Help page",
    placement: "bottom"
  }]
}
