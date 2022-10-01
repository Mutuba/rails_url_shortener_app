# frozen_string_literal: true

json.array! @urls, partial: 'urls/url', as: :url
