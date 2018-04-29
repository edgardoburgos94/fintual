require 'time'

class Portfolio
  attr_reader :stocks

  def initialize
    @stocks = []
    @regex = /([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))/
    5.times do |i|
      @stocks[i] = Stock.new
    end
    puts('')
    puts('')
    puts("||||||||||||||| FINTUAL TEST |||||||||||||||")
    puts('.')
    puts('.')
    puts('.')
  end

  def cycle
    continue = 's'
    while (continue != 'N')

      puts("Calcular ganancias entre: ")
      print "Fecha de inicio (ingrese la fecha en formato aaaa-mm-dd):"
      date_1 = gets.chomp

      print "Fecha final (ingrese la fecha en formato aaaa-mm-dd): "
      date_2 = gets.chomp

      response = profit(date_1, date_2)
      if response != "Error: Fecha en formato no aceptado"
        puts('---------------------------------------')
        puts('VALORES INICIALES Y FINALES DEL PERIODO')
        puts('---------------------------------------')
        puts('')
        puts("PRECIO EL #{date_1}: $#{response[1]}")
        puts("PRECIO EL #{date_2}: $#{response[2]}")
        puts("PERIODO EN DÍAS: $#{response[3].to_f}")
        puts('')
        puts("RETORNO ANUALIZADO ENTRE #{date_1} Y #{date_2}: #{response[0]}%")
        puts('')

      else
        puts(response)
      end
      print "¿Desea hacer otra consulta (s / N)?: "
      continue = gets.chomp
    end
  end

  def profit(date_1, date_2)


    if @regex.match(date_1) != nil && @regex.match(date_2)!= nil

      initial_value_array = []; final_value_array = []
      @stocks.each do |stock|
        initial_value_array.push(stock.price(date_1).to_i)
        final_value_array.push(stock.price(date_2).to_i)
      end
      date1_in_array = date_1.split('-')
      date2_in_array = date_2.split('-')

      initial_value = initial_value_array.inject(0){|sum,x| sum + x }
      final_value = final_value_array.inject(0){|sum,x| sum + x }
      overall_return = (final_value.to_f - initial_value.to_f)/initial_value.to_f
      number_of_days = Date.new(date2_in_array[0].to_i, date2_in_array[1].to_i, date2_in_array[2].to_i) - Date.new(date1_in_array[0].to_i, date1_in_array[1].to_i, date1_in_array[2].to_i)
      annualized_return = (((1+overall_return)**(365/number_of_days.to_f))-1)*100

      return [annualized_return, initial_value, final_value, number_of_days]
    else
      return "Error: Fecha en formato no aceptado"
    end
  end

end

class Stock
  attr_reader :record


  def initialize
    @record = {}
    (Date.new(2000, 01, 01)..Date.today).each do |date|
      @record[date]=rand(0..10)
    end
  end

  def price(date)
    date_in_array = date.split('-')

    return @record[Date.new(date_in_array[0].to_i, date_in_array[1].to_i, date_in_array[2].to_i)]
  end
end


portafolio = Portfolio.new
portafolio.cycle
