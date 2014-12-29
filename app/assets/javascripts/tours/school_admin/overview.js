var school_admin_overview = {
  id: 'school_admin_overview',
  steps: [{
    target: document.querySelector('.home'),
    content: "Welcome to LE! Let us give you a quick tour and show you how to get started.",
    placement: 'bottom',
    multipage: true,
    onNext: function() {
      window.location = "/classrooms"
    }
  }, {
    target: document.querySelector('.classrooms'),
    content: "The classrooms page allows you to create groups of students. Simply enter a name for the classroom, click create, then click the classroom name.",
    placement: "bottom"
  }, {
    target: document.querySelector('.new_classroom'),
    content: "To start, simply type a classroom name and click Create.",
    placement: "bottom",
    showNextButton: false
  }, {
    target: document.querySelector('#classrooms'),
    content: "Now that you've created your classroom, click the classroom to add a student.",
    placement: "left",
    showNextButton: false,
    multipage: true
  }, {
    target: document.querySelector('.resp-page-content'),
    content: "This is where you add students to your classroom",
    placement: "top"
  }, {
    target: document.querySelector('.btn.add-new-student'),
    content: "Click here to add a new student",
    placement: "top",
    showNextButton: false
  }, {
    target: document.querySelector('#add-new-student-modal'),
    content: "This is where you will add a new student's information. Enter your student's information and click Add",
    placement: "left",
    showNextButton: false
  }, {
    target: document.querySelector('#classroom-students'),
    content: "The new user shows up in the table.",
    placement: "top",
    multipage: true,
    onNext: function() {
      window.location = "/school_admins/bank"
    }
  }, {
    target: document.querySelector('.bank'),
    content: "The Bank page is where you manage your LE credits. You can print credits to give to your students or send them LE credits electronically.",
    placement: "bottom"
  }, {
  //   target: $('a[href=#auto-credits]')[0],
  //   content: "This tab allows you to set parameters for iNow to automatically send electronic credits to your students.",
  //   placement: "left",
  //   onShow: function() {
  //     $('a[href=#auto-credits]').click();
  //   }
  // }, {
    target: $('a[href=#print-credits]')[0],
    content: "The Print Credits tab allows you to print credit vouchers that can be given out to students. The students will use the generated code to redeem these credits.",
    placement: "top",
    onShow: function() {
      $('a[href=#print-credits]').click();
    }
  }, {
    target: $('a[href=#electronic-credits]')[0],
    content: "The Electronic Credits tab allows you to send credits to a student, or a group of students (classroom). The student will receive a system message allowing them to redeem the credits.",
    placement: "top",
    onShow: function() {
      $('a[href=#electronic-credits]').click();
    }
  }, {
    target: $('a[href=#transfer-credits]')[0],
    content: "The Transfer Credits tab allows you to transfer credits from one teacher to another.",
    placement: "top",
    onShow: function() {
      $('a[href=#transfer-credits]').click();
    }
  }, {
    target: $('a[href=#lookup-code]')[0],
    content: "The Lookup A Code tab allows you to lookup a printed credit to see details about it. From here you can tell if it was redeemed, the date it was redeemed (if applicable), and the amount.",
    placement: "top",
    onShow: function() {
      $('a[href=#lookup-code]').click();
    }
  }, {
    target: $('a[href=#auto-credits]')[0],
    content: "The Auto-Credits tab allows you to setup automatically delivered weekly credits to reward good behavior.",
    placement: "top",
    onShow: function() {
      $('a[href=#auto-credits]').click();
    }
  }, {
    target: $('a[href=#electronic-credits]')[0],
    content: "Now that you have an overviiew of what's possible, let's transfer some credits to your newly created classroom.",
    placement: "top",
    onShow: function() {
      $('a[href=#electronic-credits]').click();
    }
  }, {
    target: document.querySelector('.electronic-credits-for-classroom'),
    content: "This is where you will issue credits on a classroom level.",
    placement: "top"
  }, {
    target: document.querySelector('#classroom_id'),
    content: "Start by selecting your newly created classroom. Once you select a classroom, all of the students in the classroom will populate below.",
    placement: "right"
  }, {
    target: document.querySelector('.class_points'),
    content: "This is where you enter points. Below, you'll notice that the number of points you enter will be populated. If you were to update the points on a single line below, it would only update the points for that specific student.",
    placement: "right"
  }, {
    target: document.querySelector('#classroom_otu_code_category'),
    content: "This is where you would select a category if you wanted to distinguish what the points were for. For now, we'll leave it blank, because we haven't setup a category.",
    placement: "right"
  }, {
    target: $('.electronic-credits-for-classroom input[type=submit]'),
    content: "Once you are finished setting up the points for the classroom, you can click this button to send those credits to the students.",
    placement: "right"
  }]
}

// }, {
//   target: document.querySelector('.manage_students'),
//   content: "The Students page is where you can edit your students accounts and reset passwords if necessary.",
//   placement: "bottom"
// }, {
//   target: document.querySelector('.new-students-link'),
//   content: "The Students page is where you can edit your students accounts and reset passwords if necessary.",
//   placement: "bottom",
//   multipage: true,
//   onNext: function() {
//     window.location = "/classrooms"
//   }
// }, {
//   target: document.querySelector('.classrooms'),
//   content: "The classrooms page allows you to create groups of students. Simply enter a name for the classroom, click create, then click the classroom name.",
//   placement: "bottom"
// }, {
//   target: document.querySelector('.new_classroom'),
//   content: "Classrooms allow you to give your students LE credits quickly. If you have classrooms in iNow, they should come over automatically, but you can still create more if you like.",
//   placement: "bottom"
// }, {

// , {
//   target: $('.classroom')[0], //document.querySelector('.classroom')[0],
//   content: "You can't edit Classrooms that are synced with iNow, but any additional Classrooms you create can be customized by you.",
//   placement: "bottom",
//   multipage: true,
//   onNext: function() {
//     window.location = "/store"
//   }
// }, {
//   target: document.querySelector('.shop'),
//   content: "The Store is where you create and manage prizes or rewards for your classrooms. This page will show you all the rewards in your school.",
//   placement: "bottom"
// }, {
//   target: document.querySelector('.manage-rewards'),
//   content: "You can add a new reward or update and existing one here.",
//   placement: "bottom",
//   multipage: true,
//   onNext: function() {
//     window.location = "/school_admins/reports"
//   }
// }, {
//   target: document.querySelector('.reports'),
//   content: "Run a Purchase Report to see what items your students have purchased from the store. You can also check student Credit balances or see who's logging in.",
//   placement: "bottom"
// }
