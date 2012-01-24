# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

    individuals = Individual.create(
                                    [ 
                                      { gender: 'male',   height: 6,    weight: 180  },
                                      { gender: 'male',   height: 5.92, weight: 190  },
                                      { gender: 'male',   height: 5.58, weight: 170  },
                                      { gender: 'male',   height: 5.92, weight: 165  },
                                      { gender: 'female', height: 5,    weight: 100  },
                                      { gender: 'female', height: 5.5,  weight: 150  },
                                      { gender: 'female', height: 5.42, weight: 130  },
                                      { gender: 'female', height: 5.75, weight: 150  },
                                    ])
