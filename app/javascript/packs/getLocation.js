document.addEventListener('DOMContentLoaded', function() {
  const addressInput = document.getElementById('post_address');
  const getLocationBtn = document.getElementById('get-location-btn');

  getLocationBtn.addEventListener('click', () => {
      if ('geolocation' in navigator) {
          navigator.geolocation.getCurrentPosition(async (position) => {
              const { latitude, longitude } = position.coords;
              const response = await fetch(`https://maps.googleapis.com/maps/api/geocode/json?latlng=${latitude},${longitude}&key=${process.env.Geocoding_API_Key}`);
              const data = await response.json();
              console.log(data)
              if (data.results.length > 0) {
                  const formattedAddress = data.results[0].formatted_address;
                  addressInput.value = formattedAddress;
              } else {
                  addressInput.value = '住所が見つかりませんでした';
              }
          }, (error) => {
              console.error('位置情報の取得に失敗しました。', error);
              addressInput.value = '位置情報の取得に失敗しました';
          });
      } else {
          console.error('ブラウザがGeolocation APIをサポートしていません。');
          addressInput.value = 'Geolocation APIがサポートされていません';
      }
  });
});