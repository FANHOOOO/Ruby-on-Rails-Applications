module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  def helper_class(attri)
    if(params[:sort].to_s==attri)
      return 'hilite'
    else
      return nil
    end
  end
end
