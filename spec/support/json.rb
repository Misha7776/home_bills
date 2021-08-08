def json
  JSON.parse(response.body || response_body)
end