# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

    individuals = Individual.create(
                                    [ 
                                      { gender: 'Male',   height: 6,    height_ft: 6, height_in: 0 , weight: 180, foot_size: 12},
                                      { gender: 'Male',   height: 5.92, height_ft: 5, height_in: 10, weight: 190, foot_size: 11},
                                      { gender: 'Male',   height: 5.58, height_ft: 5, height_in: 6,  weight: 170, foot_size: 12},
                                      { gender: 'Male',   height: 5.92, height_ft: 5, height_in: 10, weight: 165, foot_size: 10},
                                      { gender: 'Female', height: 5,    height_ft: 5, height_in: 0,  weight: 100, foot_size: 6},
                                      { gender: 'Female', height: 5.5,  height_ft: 5, height_in: 6,  weight: 150, foot_size: 8},
                                      { gender: 'Female', height: 5.42, height_ft: 5, height_in: 5,  weight: 130, foot_size: 7},
                                      { gender: 'Female', height: 5.75, height_ft: 5, height_in: 9,  weight: 150, foot_size: 9}
                                    ])
