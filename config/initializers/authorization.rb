module Authorization
  class Privilege
    attr_reader :name, :human
    
    def initialize(s,n)
      @name = s
      @human = n  
    end
    
    class << self
      def register(*privs)
        privs.each do |p|
          Authorization.send :const_set, p[0].upcase, Privilege.new(p[0].upcase, p[1])
          PRIVILEGES << Authorization.send(:const_get,p[0].upcase)
        end  
      end
      
      def names
        PRIVILEGES.to_a.map {|s| s.human }
      end
      
      def privileges
        PRIVILEGES
      end
    end
  end
  
  PRIVILEGES = [] 
end

Authorization::Privilege.register  ['EDIT_PI_DELEGATE', 'Edit PI Delegate'],
  ['EDIT_PI', 'Edit PI & Project'],
  ['EDIT_PROGRESS_REPORT', 'Edit Progress Report'],
  ['EDIT_DATA', 'Edit Data Deposition Info/Link'],
  ['EDIT_DMS', 'Edit DMS Plan Sections'],
  ['VIEW_PROJECT', 'View Project Info'],
  ['VALIDATE_DATA', 'Validate Deposition Link'],
  ['VIEW_DMS', 'View DMS Plan'],
  ['EDIT_COMMENTS', 'Edit Comments for PI'],
  ['APPROVE_DMS','Approve DMS Progress']