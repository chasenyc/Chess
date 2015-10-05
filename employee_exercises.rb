class Employee

  attr_reader :salary, :boss, :name

  def initialize(name, title, salary, boss=nil)
    @name, @title, @salary, @boss = name, title, salary, boss
    add_to_boss(boss) unless boss.nil?
  end

  def bonus(multiplier)
    multiplier * salary
  end

  def add_to_boss(boss)
      boss.employees += [self]
  end

end



class Manager < Employee

  attr_accessor :employees

  def initialize(name, title, salary, boss = nil)
    @employees = []
    super(name, title, salary, boss)
    add_employees_to_boss(boss) unless boss.nil?
  end

  def bonus(multiplier)
    multiplier * total_employee_salaries
  end

  def employees=(new_employee)
    @employees += new_employee
    boss.employees += new_employee unless boss.nil?
  end

   protected

    def total_employee_salaries
      sum = 0
      employees.each do |x|
        sum += (x.is_a?(Manager) ? (x.total_employee_salaries) : x.salary)
        sum += x.salary if x.is_a? Manager
      end

      sum
    end
end
ned = Manager.new("Ned", "Founder", 1000000)

darren = Manager.new("Darren", "TA Manager", 78000, ned)

david = Employee.new("David", "TA", 10000, darren)
shawna = Employee.new("Shawna", "TA", 12000, darren)


 ned.bonus(5)
 darren.bonus(4)
 david.bonus(3)
