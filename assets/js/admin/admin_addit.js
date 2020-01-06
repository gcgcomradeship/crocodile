$(document).ready( function () {
  if ($('#table_id')){
    $('#table_id').DataTable(
      {
        "language": {
          "search": "",
          "lengthMenu": "_MENU_",
          "info": "_PAGE_ из _PAGES_",
          "infoEmpty": "0 из 0",
          "infoFiltered": "",
          "paginate": {
            "first": "<<",
            "last": ">>",
            "next": ">",
            "previous": "<"
          }
        },
        "dom":
          "<'row'<'datatable-search col-sm-12 col-md-4'f><'col-sm-12 col-md-8'>>" +
          "<'row'<'col-sm-12'tr>>" +
          "<'row datatable-bottom'<'badge badge-dark col-sm-12 col-md-1'i><'datatable-on-page col-sm-12 col-md-2'l><'datatable-pages col-sm-12 col-md-9'p>>"
      });
    }
  }
);
