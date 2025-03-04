require 'base64'
require 'json'
require 'net/https'

module Vision
  class << self
    def image_analysis(image_file)
      # APIのURL作成
      api_url = "https://vision.googleapis.com/v1/images:annotate?key=#{ENV['Google_API_KEY']}"

      # 画像をbase64にエンコード
      base64_image = Base64.encode64(image_file.tempfile.read)

      # APIリクエスト用のJSONパラメータ
      params = {
        requests: [{
          image: {
            content: base64_image
          },
          features: [
            {
              type: "SAFE_SEARCH_DETECTION"
            }
          ]
        }]
      }.to_json

      # Google Cloud Vision APIにリクエスト
      uri = URI.parse(api_url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri)
      request['Content-Type'] = 'application/json'
      response = https.request(request, params)
      result = JSON.parse(response.body)
      byebug
      # APIレスポンス出力
      if (error = result['responses'][0]['error']).present?
        raise error['message']
      else
        result_arr = result["responses"].flatten.map do |parsed_image|
          parsed_image["safeSearchAnnotation"].values
          safe_search = parsed_image["safeSearchAnnotation"]

          puts "Image #{parsed_image['id']} - Safe Search Scores:"
          puts "Medical: #{safe_search['medical']}"
          puts "Violence: #{safe_search['violence']}"
          puts "Spoof: #{safe_search['spoof']}"
          puts "Racy: #{safe_search['racy']}"
          puts "Adult: #{safe_search['adult']}"
          
          parsed_image["safeSearchAnnotation"].values

        end.flatten
        if result_arr.include?("LIKELY") || result_arr.include?("VERY_LIKELY")
          false
        else
          true
        end
      end
    end

    private

    def translate_text(text)
      translate_url = "https://translation.googleapis.com/language/translate/v2?key=#{ENV['Google_API_KEY']}"

      params = {
        q: text,
        target: 'ja', # 翻訳先の言語（日本語）
        format: 'text'
      }.to_json

      uri = URI.parse(translate_url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri, { 'Content-Type' => 'application/json' })
      response = https.request(request, params)
      response_body = JSON.parse(response.body)

      response_body.dig('data', 'translations', 0, 'translatedText') || text
      
    end
  end
end