# db/seeds.rb
Todo.create([
  { text: 'Comprar leche', is_completed: false, deleted: false },
  { text: 'Enviar correo al cliente', is_completed: true, deleted: false },
  { text: 'Llamar al doctor', is_completed: false, deleted: false }
])

puts "Datos de prueba creados."