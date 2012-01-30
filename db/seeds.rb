# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

    individuals = Individual.create(
                                    [ 
                                      { gender: 'Male',   height: 6,    weight: 180, foot_size: 12},
                                      { gender: 'Male',   height: 5.92, weight: 190, foot_size: 11},
                                      { gender: 'Male',   height: 5.58, weight: 170, foot_size: 12},
                                      { gender: 'Male',   height: 5.92, weight: 165, foot_size: 10},
                                      { gender: 'Female', height: 5,    weight: 100, foot_size: 6},
                                      { gender: 'Female', height: 5.5,  weight: 150, foot_size: 8},
                                      { gender: 'Female', height: 5.42, weight: 130, foot_size: 7},
                                      { gender: 'Female', height: 5.75, weight: 150, foot_size: 9},
                                    ])
