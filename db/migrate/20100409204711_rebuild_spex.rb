class RebuildSpex < ActiveRecord::Migration
  class Spex < ActiveRecord::Base
    acts_as_nested_set
  end
  
  def self.up
    Spex.rebuild!
    # Sort the revivals in decreasing order
    Spex.roots.each do |spex|
      done = false
      while !done
        done = true
        revivals = spex.children
        for i in 0..(revivals.length - 1)
          for j in 0..(revivals.length - i - 2)
            if revivals[j+1].year.to_i > revivals[j].year.to_i
              revivals[j+1].move_to_left_of(revivals[j])
              spex.reload
              done = false
              break
            end
          end
          if !done
            break
          end
        end
      end
    end
  end
  
  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
