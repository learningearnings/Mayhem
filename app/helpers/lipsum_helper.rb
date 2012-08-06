module LipsumHelper
  def lipsum(characters=800)
    source_text[0...characters]
  end

  private
  def source_text
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi ultricies consectetur erat, ac facilisis libero pulvinar sit amet. Aenean mauris quam, cursus vel venenatis vel, volutpat a dui. Sed venenatis orci tristique sapien dapibus vitae bibendum sapien congue. Aenean at tellus at nunc mattis suscipit et id orci. Sed volutpat molestie augue ac consequat. Aliquam ullamcorper accumsan sagittis. Curabitur turpis dui, adipiscing quis suscipit ac, vestibulum viverra erat. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.

    Sed sed ultrices ligula. Ut at mollis tellus. Cras nunc ipsum, accumsan quis accumsan scelerisque, blandit quis purus. Sed eget orci odio, eu dapibus quam. In semper sapien odio, ut fringilla lectus. Etiam risus tortor, tempus sagittis pulvinar in, sagittis nec lectus. Maecenas interdum leo nec neque fringilla dictum. Maecenas eu magna at purus vestibulum gravida sed vitae risus. Nam consectetur lacinia neque non bibendum. In consequat volutpat nisl, sit amet sodales neque molestie euismod. Aenean euismod risus ut est dapibus vehicula. Proin at lacus elit. Morbi vitae imperdiet est. Phasellus et velit sit amet dui consectetur commodo sed sed metus.

    Fusce euismod fringilla sem ut tincidunt. In in vehicula lectus. Vivamus blandit pharetra turpis sit amet lobortis. Morbi dapibus ligula sed lorem sodales pellentesque. Morbi porta purus mattis turpis luctus cursus. Curabitur non mollis tortor. Proin mollis vehicula eros vel bibendum. Nam interdum augue a odio aliquet vestibulum. Aliquam mauris elit, suscipit sit amet venenatis ut, pulvinar non dolor. Sed eget ante ut augue mattis vehicula. Praesent sed sapien arcu, id tincidunt sapien. Aliquam lobortis arcu lobortis est condimentum ultrices.

    Aliquam ullamcorper tortor quis tellus placerat at mattis risus convallis. Curabitur at nibh lectus. Fusce id lorem et eros vehicula pulvinar sed eget eros. Nulla tempus tempus luctus. Pellentesque interdum tempus neque, vel gravida velit tempor ac. Maecenas lacus massa, rutrum sit amet tempor et, euismod in dolor. Etiam consectetur nulla nec ante consectetur aliquet. Nam lobortis libero eu nunc euismod viverra. Vestibulum euismod ornare lorem id cursus. Maecenas bibendum porta quam id molestie. Etiam vitae posuere ipsum. Nullam augue neque, mollis sit amet auctor id, commodo et nisi. Phasellus scelerisque sodales condimentum. Vestibulum convallis tincidunt tortor, ut mattis dolor tincidunt quis.

    Etiam eros arcu, fermentum in pharetra a, pulvinar vitae turpis. Suspendisse potenti. Fusce nulla tellus, dictum vitae cursus vel, scelerisque quis leo. Proin a elementum tellus. Nulla fermentum facilisis nunc id euismod. Sed viverra augue eget sem faucibus placerat. Nullam vitae tellus mi, et posuere magna. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed nec leo risus. Etiam elementum vestibulum mauris at auctor. Morbi id urna turpis, a aliquet ligula. "
  end
end
