module ApplicationHelper

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def person_correlation(user_1_ratings, user_2_ratings)
  shared_items = user_1_ratings.keys.reject{|k| user_2_ratings[k].nil? }
  number_of_shared_items = shared_items.length.to_f

  #if there is nothing in commin return 0 
  return 0 if number_of_shared_items == 0
   
  averge_rating_of_user_1 = shared_items.inject(0) do |agg, k|
    agg + user_1_ratings[k]
  end

  averge_rating_of_user_1 = averge_rating_of_user_1 / number_of_shared_items

  averge_rating_of_user_2 = shared_items.inject(0) do |agg, k|
    agg + user_2_ratings[k]
  end

  averge_rating_of_user_2 = averge_rating_of_user_2 / number_of_shared_items

  numerator = shared_items.inject(0) do |agg, k|
    user_1 = user_1_ratings[k] - averge_rating_of_user_1
    user_2 = user_2_ratings[k] - averge_rating_of_user_2
    agg + (user_1 * user_2)
  end

  square_1 = shared_items.inject(0) do |agg, k| 
    agg + ((user_1_ratings[k] + averge_rating_of_user_1)**2)
  end 
  square_2 = shared_items.inject(0) do |agg, k| 
    agg + ((user_2_ratings[k] + averge_rating_of_user_2)**2)
  end 

  denominator = Math.sqrt(square_1 * square_2)

  return numerator.to_f / denominator.to_f
end

end
