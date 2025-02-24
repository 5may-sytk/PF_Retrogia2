let map;
let marker;

async function initMap() {
  const { Map } = await google.maps.importLibrary("maps");

  // gon変数から緯度と経度を取得
  const latitude = gon.latitude;
  const longitude = gon.longitude;
  
  // 地図の中心をgon変数から取得した緯度と経度に設定
  const center = { lat: latitude, lng: longitude };

  map = new Map(document.getElementById("map"), {
    center: center, 
    zoom: 15,
    mapTypeControl: false
  });

  marker = new google.maps.Marker({
    position: center, 
    map: map 
  });
}