$(document).ready(function() {

   // users: diffrent colors for active and inactive users
   $("tr.jq_users_active_false").addClass('users_inactive').hide();

   // users: hide inactive users
   $("a.jq_users_hide_inactive").click(function() {
      $(".users_inactive").toggle();   
   });
   
});
