# db/seeds.rb
Todo.destroy_all

# Creando registros con la fecha y hora actual
Todo.create([
  { text: 'Comprar leche', is_completed: false, deleted: false, created_at: Time.now, updated_at: Time.now },
  { text: 'Enviar correo al cliente', is_completed: true, deleted: false, created_at: Time.now, updated_at: Time.now },
  { text: 'Llamar al doctor', is_completed: false, deleted: false, created_at: Time.now, updated_at: Time.now },
  { text: 'Leer un libro', is_completed: true, deleted: false, created_at: Time.now, updated_at: Time.now },
  { text: 'Practicar yoga', is_completed: false, deleted: false, created_at: Time.now, updated_at: Time.now },
  { text: 'Revisar el proyecto', is_completed: true, deleted: false, created_at: Time.now, updated_at: Time.now }
])

puts "Datos de prueba creados."
