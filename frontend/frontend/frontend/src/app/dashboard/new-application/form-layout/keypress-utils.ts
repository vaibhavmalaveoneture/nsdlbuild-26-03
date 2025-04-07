export class KeypressUtils {

    static allowNumberOnly(event: KeyboardEvent): void {
      const allowedPattern = /^[0-9]$/;
      if (!allowedPattern.test(event.key)) {
        event.preventDefault();
      }
    }
  
    static allowNumberOnlyPhone(event: KeyboardEvent): void {
      const allowedPattern = /^[0-9+]$/;
      if (!allowedPattern.test(event.key)) {
        event.preventDefault();
      }
    }
  
    static allowAlphaNumeric(event: KeyboardEvent): void {
      const allowedPattern = /^[A-Za-z0-9 ]$/;
      if (!allowedPattern.test(event.key)) {
        event.preventDefault();
      }
    }
  
    static onlyAllowAlphaNumeric(event: KeyboardEvent): void {
      const allowedPattern = /^[A-Za-z0-9]$/;
      if (!allowedPattern.test(event.key)) {
        event.preventDefault();
      }
    }
  
  }
  