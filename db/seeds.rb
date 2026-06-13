admin = User.find_or_create_by!(email: "admin@wedding.com") do |user|
  user.first_name = "Wedding"
  user.last_name = "Admin"
  user.phone = "+1234567890"
  user.role = :admin
  user.password = "password123"
  user.password_confirmation = "password123"
end

family = User.find_or_create_by!(email: "family@wedding.com") do |user|
  user.first_name = "Family"
  user.last_name = "Member"
  user.phone = "+1234567891"
  user.role = :family_member
  user.password = "password123"
  user.password_confirmation = "password123"
end

events_data = [
  { title: "Engagement", venue: "Rose Garden", event_date: 30.days.from_now.to_date },
  { title: "Mehndi", venue: "Family Home", event_date: 45.days.from_now.to_date },
  { title: "Haldi", venue: "Family Home", event_date: 50.days.from_now.to_date },
  { title: "Sangeet", venue: "Grand Ballroom", event_date: 55.days.from_now.to_date },
  { title: "Wedding", venue: "Sacred Temple", event_date: 60.days.from_now.to_date },
  { title: "Reception", venue: "Luxury Hotel", event_date: 61.days.from_now.to_date }
]

events_data.each do |data|
  event = admin.events.find_or_create_by!(title: data[:title]) do |e|
    e.description = "#{data[:title]} celebration"
    e.venue = data[:venue]
    e.event_date = data[:event_date]
    e.start_time = "18:00"
    e.end_time = "23:00"
    e.status = :planned
  end

  5.times do |i|
    event.guests.find_or_create_by!(email: "guest#{i + 1}@#{data[:title].downcase}.com") do |g|
      g.first_name = "Guest"
      g.last_name = "#{i + 1}"
      g.side = i.even? ? :bride : :groom
      g.rsvp_status = :pending
    end
  end
end

%w[Photographer Caterer Decorator].each_with_index do |name, i|
  admin.vendors.find_or_create_by!(vendor_name: "Premium #{name}") do |v|
    v.vendor_type = %i[photographer caterer decorator][i]
    v.contact_person = "#{name} Lead"
    v.contract_amount = 50_000 + (i * 10_000)
    v.paid_amount = 20_000
  end
end

%w[Venue Catering Decoration Photography].each_with_index do |cat, i|
  admin.expenses.find_or_create_by!(title: "#{cat} Expense") do |e|
    e.category = %i[venue catering decoration photography][i]
    e.estimated_amount = 100_000
    e.actual_amount = 75_000 + (i * 5000)
    e.payment_status = :partial
  end
end

admin.albums.find_or_create_by!(title: "Pre-Wedding") do |a|
  a.description = "Pre-wedding photo collection"
end

DEFAULT_CHECKLIST = [
  { title: "Book wedding venue", category: "venue", position: 1 },
  { title: "Finalize guest list", category: "guests", position: 2 },
  { title: "Send save-the-date invites", category: "guests", position: 3 },
  { title: "Hire photographer", category: "photography", position: 4 },
  { title: "Book caterer", category: "catering", position: 5 },
  { title: "Choose wedding outfits", category: "attire", position: 6 },
  { title: "Confirm vendors & contracts", category: "vendors", position: 7 },
  { title: "Plan mehndi & sangeet", category: "general", position: 8 },
  { title: "Arrange transportation", category: "general", position: 9 },
  { title: "Marriage registration / legal", category: "legal", position: 10 },
  { title: "Final RSVP follow-up", category: "guests", position: 11 },
  { title: "Rehearsal & day-of timeline", category: "general", position: 12 }
].freeze

DEFAULT_CHECKLIST.each do |item|
  admin.tasks.find_or_create_by!(title: item[:title]) do |t|
    t.category = item[:category]
    t.position = item[:position]
    t.status = :pending
  end
end

puts "Seeded admin: admin@wedding.com / password123 (full access)"
puts "Seeded family: family@wedding.com / password123 (view + RSVP, no admin actions)"
puts "Guests are invite records — they do not log in; use QR / WhatsApp invite."
