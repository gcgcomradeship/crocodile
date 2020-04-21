// ClassicEditor
//   .create( document.querySelector( '#editor' ) )
//   .catch( error => {
//       console.error( error );
//   } );
if (document.querySelector( '#editor' )){
  CKEDITOR.replace( 'editor' );
}
