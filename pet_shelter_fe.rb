class Pet
  attr_reader :animal, :name

  def initialize(animal, name)
    @animal = animal
    @name = name
  end

  def to_s
    "a #{animal} named #{name}"
  end
end

class Owner
  attr_reader :name, :pets

  def initialize(name)
    @name = name
    @pets = []
  end

  def add_pet(pet)
    @pets << pet
  end

  def number_of_pets
    pets.size
  end

  def print_pets
    puts pets
  end
end

class Shelter
  attr_reader :pet_inventory

  def initialize
    @owners = {}
    @pet_inventory = []
  end

  def take_in_pets(pets)
    @pet_inventory += pets
  end

  def adopt(owner, pet)
    owner.add_pet(pet)
    @owners[owner.name] ||= owner
    @pet_inventory.delete(pet)
  end

  def print_adoptions
    if @pet_inventory.length > 0
      puts "The Animal Shelter has the following unadopted pets:"
      puts @pet_inventory
      puts
    end

    @owners.each_pair do |name, owner|
      puts "#{name} has adopted the following pets:"
      owner.print_pets
      puts
    end
  end
end

butterscotch = Pet.new('cat', 'Butterscotch')
pudding = Pet.new('cat', 'Pudding')
darwin = Pet.new('bearded dragon', 'Darwin')
kennedy = Pet.new('dog', 'Kennedy')
sweetie = Pet.new('parakeet', 'Sweetie Pie')
molly = Pet.new('dog', 'Molly')
chester = Pet.new('fish', 'Chester')
asta = Pet.new('dog', 'Asta')
laddie = Pet.new('dog', 'Laddie')
fluffy = Pet.new('cat', 'Fluffy')
kat = Pet.new('cat', 'Kat')
ben = Pet.new('cat', 'Ben')
chatterbox = Pet.new('parakeet', 'Chatterbox')
bluebell = Pet.new('parakeet', 'Bluebell')

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')

shelter = Shelter.new
shelter.take_in_pets([asta, laddie, fluffy, kat, ben, chatterbox, bluebell,
                      butterscotch, pudding, darwin, kennedy, sweetie, molly,
                      chester])

shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)

shelter.print_adoptions

puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."
puts "The Animal Shelter has #{shelter.pet_inventory.size} unadopted pets."
