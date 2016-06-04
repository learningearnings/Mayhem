  $(document).ready( function () {
    var rows_selected = [];

    var table = $('#credit_report_table').DataTable({
     "bPaginate": false,
      'columnDefs': [{
        'targets': 0,
         'searchable': false,
         'orderable': false,
         'width': '1%',
         'className': ''
        }],
       'order': [[1, 'asc']]
     }); 
    // Handle click on "Select all" control
    $('#example-select-all').on('click', function(){
      // Get all rows with search applied
      var rows = table.rows({ 'search': 'applied' }).nodes();
      // Check/uncheck checkboxes for all rows in the table
      $('input[type="checkbox"]', rows).prop('checked', this.checked);
    });
    // Handle click on checkbox to set state of "Select all" control
    $('#credit_report_table tbody').on('change', 'input[type="checkbox"]', function(){
      // If checkbox is not checked
      if(!this.checked){
        var el = $('#example-select-all').get(0);
        // If "Select all" control is checked and has 'indeterminate' property
        if(el && el.checked && ('indeterminate' in el)){
          // Set visual state of "Select all" control 
          // as 'indeterminate'
          el.indeterminate = true;
        }
      }
    });
    $('#print-report').on('click', function(e){
      e.preventDefault(); //prevents the default submit action
      $('.button_to').submit();
    });
    $('.button_to').submit(function(e){
      var form = this;
      // Iterate over all checkboxes in the table
      table.$('input[type="checkbox"]').each(function(){
         // If checkbox doesn't exist in DOM
       
      // If checkbox is checked
          if(this.checked){
             // Create a hidden element 
             $(form).append(
                $('<input>')
                   .attr('type', 'hidden')
                   .attr('name', this.name)
                   .val(this.value)
             );
             $('<input />').attr('type', 'hidden')
              .attr('name', 'start_date')
              .attr('value', $('#start_date').text())
              .appendTo('.button_to');
            $('<input />').attr('type', 'hidden')
              .attr('name', 'end_date')
              .attr('value', $('#end_date').text())
              .appendTo('.button_to');

         }
       
      });
   });

    $('.history-action').click(function(e) {
      var el = $(e.currentTarget);
      // Set title for modal
      $('#history-modal .title').html("Student: " + el.data("name"));
      $.ajax({
        url:'/reports/student_earning_transactions',
        type: 'POST',
        data: { student_id: el.data("id"),
                start_date: $('#start_date').text(),
                end_date: $('#end_date').text(),
                credit_type: el.data("credit-type"),
                      } ,
        success:function(data) {
          $("#credit-history").html(data);
        }
      });
    });

    // On hide of modal, we need to clear out the student's data
    $('#history-modal').on('hidden', function() {
      $('#checking-history').html("Loading Checking History...");
      $('#savings-history').html("Loading Savings History...");
    });
    // On click of student name, we will setup spinners
    //  and load checkings/savings data to return to the
    //  modal.

  });
