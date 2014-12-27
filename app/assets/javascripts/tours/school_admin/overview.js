var school_admin_overview = {
  id: 'school_admin_overview',
  steps: [{
    target: document.querySelector('.home'),
    content: "Welcome to LE! Let us give you a quick tour and show you how to get started.",
    placement: 'bottom',
    multipage: true,
    onNext: function() {
      window.location = "/school_admins/bank"
    }
  }, {
    target: document.querySelector('.bank'),
    content: "The Bank page is where you manage your LE credits. You can print credits to give to your students or send them LE credits electronically.",
    placement: "bottom"
  }, {
    target: $('a[href=#auto-credits]')[0],
    content: "This tab allows you to set parameters for iNow to automatically send electronic credits to your students.",
    placement: "left",
    multipage: true,
    onNext: function() {
      window.location = "/teachers/bulk_students"
    }
  }, {
    target: document.querySelector('.manage_students'),
    content: "The Students page is where you can edit your students accounts and reset passwords if necessary.",
    placement: "bottom"
  }, {
    target: document.querySelector('.new-students-link'),
    content: "The Students page is where you can edit your students accounts and reset passwords if necessary.",
    placement: "bottom",
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
    content: "Classrooms allow you to give your students LE credits quickly. If you have classrooms in iNow, they should come over automatically, but you can still create more if you like.",
    placement: "bottom"
  }, {
    target: $('.classroom')[0], //document.querySelector('.classroom')[0],
    content: "You can't edit Classrooms that are synced with iNow, but any additional Classrooms you create can be customized by you.",
    placement: "bottom",
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
    placement: "bottom",
    multipage: true,
    onNext: function() {
      window.location = "/school_admins/reports"
    }
  }, {
    target: document.querySelector('.reports'),
    content: "Run a Purchase Report to see what items your students have purchased from the store. You can also check student Credit balances or see who's logging in.",
    placement: "bottom"
  }]
}
