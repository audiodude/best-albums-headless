export function registerAlbumQidLoader() {
  document.addEventListener('turbo:load', function () {
    console.log('load z');
    const input = document.getElementById('album_qid');
    const link = document.getElementById('lookup-btn');
    if (!input || !link) {
      console.log('Couldnt find input or link, skipping');
      return;
    }

    link.href = `/albums/wikidata/${input.value}`;
    input.addEventListener('input', function (event) {
      link.href = `/albums/wikidata/${input.value}`;
    });
  });
}
