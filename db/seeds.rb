# db/seeds.rb
Todo.destroy_all

Todo.create([
  { text: 'Comprar leche', is_completed: false, deleted: false, created_at: 2.days.ago, updated_at: 2.days.ago },
  { text: 'Enviar correo al cliente', is_completed: true, deleted: false, created_at: 10.days.ago, updated_at: 1.day.ago },
  { text: 'Llamar al doctor', is_completed: false, deleted: false, created_at: 5.days.ago, updated_at: 5.days.ago },
  { text: 'Leer un libro', is_completed: true, deleted: false, created_at: 3.days.ago, updated_at: 3.days.ago },
  { text: 'Practicar yoga', is_completed: false, deleted: true, created_at: 4.days.ago, updated_at: 4.days.ago },
  { text: 'Revisar el proyecto', is_completed: true, deleted: false, created_at: 6.days.ago, updated_at: 2.hours.ago }
])

puts "Datos de prueba creados."
